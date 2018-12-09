<template>
  <div id="myApp">
    <LoadingMask></LoadingMask>
    <UserNav :parentMenu="parentMenu" :childMenu="childMenu" :navMethod="navMethods"></UserNav>
    <!-- <UserNav :parentMenu="parentMenu" :childMenu="childMenu"></UserNav> -->
    <router-view/>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import UserNav from './components/UserNav'
import LoadingMask from './components/LoadingMask'
export default {
  name: 'App',
  components: {UserNav, LoadingMask},
  data(){
    return {}
  },
  computed:{
    ...mapState([
      'userName',
      'hasWalletExt',
      'backEndScore',
      'best'
    ]),
    parentMenu(){
      if(this.userName){
        return {
          title: this.userName,
          path: ''
        }
      }else{
        return {
          title: 'Login',
          path: 'login'
        }
      }
    },
    childMenu(){
      if(this.userName){
        var childMenuArr = [
          {
            title: 'Logout',
            path: '',
            method: 'logout'
          }
        ]
        if(this.hasWalletExt){
          if(this.backEndScore&&this.backEndScore>this.best.exactScore){
            childMenuArr.push({
              title: 'OnChain',
              method: 'onChain'
            })
          }
          if(this.backEndScore&&this.backEndScore>0&&this.backEndScore==this.best.exactScore){
            childMenuArr.push({
              title: 'Withdraw',
              method: 'withdraw'
            })
          }
          
        }
        return childMenuArr;
      }else{
        return [
          {
            title: 'Register',
            path: 'register'
          }
        ]
      }
    },
    navMethods(){
      if(this.userName){
        return {
          logout: this.logout,
          withdraw: this.withdraw,
          onChain: this.onChain
        }
      }else{
        return {}
      }
    }
  },
  methods:{
    logout(){
        this.$store.commit('CHANGE_LOADING_MASK', {
          loadingMaskShow: true
        })
        this.$store.dispatch('LOGOUT')
        .then(
          res=>{
            this.$store.commit('CHANGE_LOADING_MASK', {
              loadingMaskShow: false
            })
            if(res.data.success){
              this.$store.commit('SET_USERNAME', {userName: null})
            }else{
              alert('出现错误：' + res.data.msg);
            }
          },
          err=>{
            this.$store.commit('CHANGE_LOADING_MASK', {
              loadingMaskShow: false
            })
            if(err.data&&err.data.msg){
              alert('出现错误：' + err.data.msg);
            }else{
              alert('出现错误！')
            }
          }
        )
    },
    withdraw(){
      this.$store.dispatch('WITHDRAW')
      .then(
        res=>{
          if(res.data.success){
            console.log('【提现成功】')
            alert('此功能正在开发，敬请期待:)')
          }else{
            alert('出现错误：'+res.data.msg)
          }
        },
        err=>{
          alert('出现错误：'+err.data.msg)
        }
      )
    },
    onChain(){
      this.$store.dispatch('SAVE_STORE', {
        type: 'exact',
        scoreData: {
          score:  this.backEndScore,
          misses:0,
          missesTgt: 0
        }
      })
      .then(
        res => {
          this.$store.commit('CHANGE_LOADING_MASK', {
            loadingMaskShow: false
          })
          if(res.status === 1){
            this.$store.commit('SET_SCORE', {
              exactScore: this.$store.state.now.score,
              exactMisses: /*this.$store.state.now.misses*/0,
              exactMissesTgt: /*this.$store.state.now.missesTgt*/0,
              pressScore: 0,
              pressMisses: 0,
              pressMissesTgt: 0,
            })
          }else{
            alert(res.execute_result)
          }
        },
        err => {
          this.$store.commit('CHANGE_LOADING_MASK', {
            loadingMaskShow: false
          })
          alert(err.execute_result)
        }
      )
    }
  },
  mounted(){
    this.$store.dispatch('GET_CURRENT_USER').then(res=>{},err=>{})
  }
}
</script>

<style src="./assets/css/main.css"></style>
<style>
*{
  margin: 0px;
  padding: 0px;
}
html, body{
  width: 100%;
  height: 100%;
}
#myApp{
  width: 100%;
  height: 100%;
  background: url(./assets/img/bg.gif) repeat;
}

</style>
