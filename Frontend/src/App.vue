<template>
  <div id="myApp">
    <UserNav :parentMenu="parentMenu" :childMenu="childMenu" :navMethod="navMethods"></UserNav>
    <!-- <UserNav :parentMenu="parentMenu" :childMenu="childMenu"></UserNav> -->
    <router-view/>
  </div>
</template>

<script>
import UserNav from './components/UserNav'
export default {
  name: 'App',
  components: {UserNav},
  data(){
    console.log(this.$store.hitsPoint, '【this.$store.userName】')
    if(!this.$store.userName&&false){
      return{
        parentMenu:{
          title: 'Login',
          path: 'login'
        },
        childMenu:[
          {
            title: 'Register',
            path: 'register'
          }
        ],
        navMethods:{}
      }
    }else{
      return{
        parentMenu:{
          title: 'Login',
          path: 'login',
          method: 'clickItem'
        },
        childMenu:[
          {
            title: 'Register',
            path: 'register',
            method: 'clickItem1'
          }
        ],
        navMethods:{
          clickItem: this.clickItem,
          clickItem1: this.clickItem1,
        }
      }
    }
    
  },
  methods:{
    clickItem(){
        console.log('clickItem')
    },
    clickItem1(){
        console.log('clickItem111')
    },
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
