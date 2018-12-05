<template>
  <div id="myApp">
    <UserNav :parentMenu="parentMenu" :childMenu="childMenu" :navMethod="navMethods"></UserNav>
    <!-- <UserNav :parentMenu="parentMenu" :childMenu="childMenu"></UserNav> -->
    <router-view/>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import UserNav from './components/UserNav'
export default {
  name: 'App',
  components: {UserNav},
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
              // method: 'logout'
            })
          }
          if(this.backEndScore&&this.backEndScore>0&&this.backEndScore==this.best.exactScore){
            childMenuArr.push({
              title: 'Withdraw',
              // method: 'logout'
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
        }
      }else{
        return {}
      }
    }
  },
  methods:{
    logout(){
        this.$store.dispatch('LOGOUT')
        .then(
          res=>{
            if(res.data.success){
              this.$store.commit('SET_USERNAME', {userName: null})
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
    },
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
