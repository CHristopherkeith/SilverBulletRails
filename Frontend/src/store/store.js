import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import router from 'vue-router'
import * as types from "./type.js"
import NebPay from 'nebpay.js'
import Nebulas from 'nebulas'

NebPay.config = {
	testnetUrl: "https://testnet.nebulas.io",
	mainnetUrl: "https://mainnet.nebulas.io"
}
// const contractAddress = 'n21Rvxijhp9u8ubkWYotFPDnWLfGnpWgXSy';
// const contractAddress = 'n1mhwrNzZgrFDUTKJAZjhMD71DBRMeWDu9J';
const contractAddress = 'n1jT2w44HcCUtWrR8RxVuwVpk89KhN15GUC';
const neb = new Nebulas.Neb();
const chainID = 1001;
const nebPay = new NebPay();
neb.setRequest(new Nebulas.HttpRequest("https://testnet.nebulas.io"));
// neb.setRequest(new Nebulas.HttpRequest("https://mainnet.nebulas.io"));

Vue.use(Vuex)

const store = new Vuex.Store({
	state: {
		loadingMaskShow: false,
		hitsPoint: 300,
		missesPoint: -100,
		missesTgtPoint: -300,
		playing: false,
		now: {
			score: 0,
			hits: 0,
			misses: 0,
			missesTgt: 0,
			totalTarget: 0
		},
		hasWalletExt: true,
		userAddress: '',
		best: {
			exactScore: 0,
			exactMisses: 0,
			exactMissesTgt: 0,
			pressScore: 0,
			pressMisses: 0,
			pressMissesTgt: 0,
		},
		// 用户信息
		userId: null,
		userName: null,
		// login: true,
	},
	mutations: {
		[types.CHANGE_SCORE](state,payload){
			state.now.score = state.now.hits * state.hitsPoint + state.now.misses * state.missesPoint + state.now.missesTgt * state.missesTgtPoint;
		},
		[types.ADD_HITS](state,payload){
			if(state.playing){
				state.now.hits += 1;
				this.commit('CHANGE_SCORE');
			}
		},
		[types.CLEAR_SCORE](state,payload){
			state.now = {
				score: 0,
				hits: 0,
				misses: 0,
				missesTgt: 0,
				totalTarget: 0
			};
		},
		[types.CHECK_WALLET_EXT](state,payload){
			setTimeout(()=>{
				if(typeof(webExtensionWallet) === "undefined"){
					state.hasWalletExt = false;
				}else{
					state.hasWalletExt = true;
				}
			},100)
		},
		[types.SET_USER_ADDRESS](state,payload){
			state.userAddress = payload.userAddress;
		},
		[types.SET_SCORE](state, payload){
			state.best = payload;
			state.best.exactScore = 0;
		},
		[types.ADD_MISSES](state,payload){
			if(state.playing){
				state.now.misses += 1;
				this.commit('CHANGE_SCORE');
			}
		},
		[types.ADD_TOTAL_TARGET](state,payload){
			if(state.playing){
				state.now.totalTarget += 1;
			}
		},
		[types.ADD_MISSES_TARGET](state,payload){
			if(state.playing){
				state.now.missesTgt += 1;
				this.commit('CHANGE_SCORE');
			}
		},
		[types.SET_PLAYING](state,payload){
			state.playing = payload.playingState;
		},
		[types.CHANGE_LOADING_MASK](state,payload){
			state.loadingMaskShow = payload.loadingMaskShow;
		},
		[types.CHANGE_LOADING_MASK](state,payload){
			state.loadingMaskShow = payload.loadingMaskShow;
		},
		[types.SET_USERNAME](state,payload){
			state.userName = payload.userName;
			console.log(state.userName, '【state.userName】')
		},
	},
	actions: {
		[types.GET_USER_ADDRESS]({commit, state, dispatch}){
			return new Promise((resolve, reject)=>{
				// console.log("********* get account ************")
			    window.postMessage({
			        "target": "contentscript",
			        "data":{
			        },
			        "method": "getAccount",
			    }, "*");
			    let listenerFunc = function(e) {
				    if (!!e.data.data && !!e.data.data.account) {
				        resolve({userAddress: e.data.data.account})
				    }
				}
			    window.removeEventListener('message', listenerFunc);
			    window.addEventListener('message',listenerFunc);
			})
			
		},
		[types.GET_ACCOUNT_STATE]({commit, state, dispatch}){
			return new Promise((resolve, reject) => {
				neb.api.getAccountState(state.userAddress)
				.then(
					res => {resolve(res)},
					err => {reject(err);}
				)
			})
		},
		[types.GET_STORE]({commit, state}, res){
			// 使用call方法（不花费手续费）
			return new Promise((resolve, reject) => {
				neb.api.call({
	            	chainID,
	            	from: state.userAddress,
	            	to: contractAddress,
	            	value: 0,
	            	nonce: parseInt(res.nonce) + 1,
	            	gasPrice: 1000000,
				   	gasLimit: 2000000,
				   	contract: {
				       function: "getScore",
				       args: "[0]"
				   }
	            }).then(
	            	res => {
	            		let result = JSON.parse(res.result || res);
	            		resolve(result);
	            	},
	            	err => {
						reject(err);
					}
	            )
			})
		},
		[types.SAVE_STORE]({commit, state}, payload={type: 'exact'}){
			let value = JSON.stringify({
				// score: parseInt(state.best.exactScore)+1,
				score:  state.now.score,
	            misses: state.now.misses,
	            missesTgt: state.now.missesTgt
			});
			let type = payload.type;
			return new Promise((resolve, reject) =>{
				nebPay.call(contractAddress, 0, 'saveScore',JSON.stringify([value, type]), {
					qrcode: {showQRCode: false},
					extension: {openExtension: true},
					callback: NebPay.config.testnetUrl,
					listener: (serialNumber, result)=>{
						if( !(result&&Object.prototype.toString.call(result) === '[object Object]') ){
							console.log('【cancle】')
							return
						}
						commit('CHANGE_LOADING_MASK', {
				          loadingMaskShow: true
				        })
						const intervalQuery = setInterval(()=>{
							funcIntervalQuery();
						}, 2000)
						function funcIntervalQuery(){
							neb.api.getTransactionReceipt(result.txhash)
							.then(
								res => {
									if(res.status === 1 || res.status === 0){
										// console.log(res, '【res getTransactionReceipt】');
										clearInterval(intervalQuery);
										resolve(res);
									}
								},
								err => {
									console.log(err, '【err getTransactionReceipt】')
									clearInterval(intervalQuery);
									reject(err);
								}
							)
						}
					}
				})
			})
		},
		[types.GET_NUM_OF_PLAYER]({commit, state}, payload){
			return new Promise((resolve, reject)=>{
				neb.api.call({
	            	chainID,
	            	from: state.userAddress,
	            	to: contractAddress,
	            	value: 0,
	            	nonce: parseInt(payload.nonce) + 1,
	            	gasPrice: 1000000,
				   	gasLimit: 2000000,
				   	contract: {
				       function: "getDataSize",
				       args: "[0]"
				   }
	            }).then(
	            	res => {
	            		// console.log(res, '【GET_NUM_OF_PLAYER res】')
	            		resolve(res);
	            	},
	            	err => {
	            		console.log(err, '【GET_NUM_OF_PLAYER err】')
						reject(err);
					}
	            )
			})
		},
		[types.FOR_EACH]({commit, state}, payload){
			return new Promise((resolve, reject) => {
				neb.api.call({
	            	chainID,
	            	from: state.userAddress,
	            	to: contractAddress,
	            	value: 0,
	            	nonce: parseInt(payload.nonce) + 1,
	            	gasPrice: 1000000,
				   	gasLimit: 2000000,
				   	contract: {
				       function: "forEach",
				       args: "[10, 0]"
				   }
	            }).then(
	            	res => {
	            		// console.log(res, '【FOR_EACH res】')
	            		resolve(res);
	            	},
	            	err => {
	            		// console.log(err, '【FOR_EACH err】')
						reject(err);
					}
	            )
			})
		},
		[types.VERIFY_SCORE]({commit, state}, payload){
			return new Promise((resolve, reject)=>{
				axios.get('/silver_bullets/foo', {
					a: 'a',
					b: 'b'
				})
				.then(
					res=>{
						resolve(res);
					},
					err=>{
						console.log('err')
						reject(err);
					}
				)
				.catch(err=>{
					console.log('catch')
					reject(err);
				})
			})
		},
		[types.REGISTER]({commit, state}, payload){
			console.log(payload, '【REGISTER payload】')
			return new Promise((resolve, reject)=>{
				axios.post('/users/register', payload)
				.then(
					res=>{
						if(res.data.success){
							resolve(res);
						}else{
							reject(res);
						}
					},
					err=>{
						console.log('err')
						reject(err);
					}
				)
				.catch(err=>{
					console.log('catch')
					reject(err);
				})
			})
		},
		[types.LOGIN]({commit, state}, payload){
			console.log(payload, '【REGISTER payload】')
			return new Promise((resolve, reject)=>{
				axios.post('/users/login', payload)
				.then(
					res=>{
						if(res.data.success){
							resolve(res);
						}else{
							reject(res);
						}
					},
					err=>{
						console.log('err')
						reject(err);
					}
				)
				.catch(err=>{
					console.log('catch')
					reject(err);
				})
			})
		}
	}
})

export default store