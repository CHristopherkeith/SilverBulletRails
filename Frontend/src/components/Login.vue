<template>
  <div class="login" :class="{loginCls: login&&false}">
    <!-- <h1>{{ msg }}</h1> -->
    <div class="loginContent">
    	<span class="loginTitle" >Username</span>
    	<input v-model="username" class="loginInput" type="text" placeholder="Pick a username" />
    	<span class="loginTitle" v-show="!login">Email</span>
    	<input v-model="email" class="loginInput" type="text" placeholder="you@example.com" v-show="!login"/>
    	<span class="loginTitle">Password</span>
    	<input v-model="password" class="loginInput" type="password" placeholder="Create a password" />
    	<button class="loginBtn" @click="loginOrRegister()">{{msg}}</button>
    	<span class="newAccount" v-show="login">New to SilverBullet? <router-link to="/register">Create an account.</router-link></span>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
export default {
  name: 'Login',
  props: ['login'],
  data () {
    return {
      // msg: 'Register for SilverBullet',
      // login: false
      username: '',
      email: '',
      password: ''
    }
  },
  methods: {
  	loginOrRegister(){
  		if(this.login){
  			console.log('【login】')
  		}else{
  			console.log('【register】')
  			this.$store.dispatch('REGISTER',{
  				username: this.username,
  				email: this.email,
  				password: this.password
  			})
  			.then(
  				res=>{
  					if(res.data.success){
  						alert('注册成功，请登录');
  						this.$router.push({path: 'login'});
  					}else{
  						alert('出现错误：' + res.data.msg);
  					}
  				},
  				err=>{
  					if(err.data&&err.data.msg){
		              alert('出现错误：' + err.data.msg);
		            }else{
		              alert('出现错误！')
		            }
  				}
  			)
  		}
  	}
  },
  computed:{
  	// ...mapState(['login']),
  	msg(){
  		return this.login ? 'Login for SilverBullet' : 'Register for SilverBullet';
  	}
  },
  created(){
  	console.log(this.login, '【login】')
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
	.login{
		width: 380px;
		height: 400px;
		background-color: #fafbfc;
		position: absolute;
		top: 0;
		bottom: 0;
		left: 0;
		right: 0;
		padding: auto;
		margin: auto;
		border-radius: 3px;
	}
	.loginCls{
		height: 300px;
	}
	.loginContent{
		height: 100%;
		width: 100%;
		padding: 24px;
		box-sizing: border-box;
	}
	.loginTitle{
		display: block;
		margin-bottom: 10px;
		font-size: 14px;
		color: #5b7492;
		font-weight: bolder;
	}
	.loginInput{
		margin-bottom: 20px;
		height: 45px;
		width: 100%;
		font-size: 16px;
	    border-radius: 5px;
	    outline: none;
        background-color: #fafbfc;
        border: 1px solid #d1d5da;
        box-shadow: inset 0 1px 2px rgba(27,31,35,.075);
        color: #24292e;
        vertical-align: middle;
        padding: 10px;
        box-sizing: border-box;
	}
	.loginBtn{
		height: 65px;
		width: 100%;
	    padding: 20px 32px;
	    background-color: #304053;
	    border: none;
	    border-radius: 3px;
	    color: #fff;
        cursor: pointer;
        font-size: 16px;
        font-weight: bolder;
        outline: none;
        transition: all 0.2s;
	}
	.loginBtn:hover{
		background-color: #5b7492;
	}
	.newAccount{
		color: #24292e;
		font-size: 14px;
		display: block;
		width: 100%;
		height: 50px;
		line-height: 50px;
		text-align: center;
		border: 1px solid #d8dee2;
		box-sizing: border-box;
		margin-top: 20px;
	}
	.newAccount a:link, .newAccount a:visited{
		text-decoration: none;
		color: #0366d6;
	}
	.newAccount a:hover{
		text-decoration: underline;
		color: #0366d6;
	}
</style>
