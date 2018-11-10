<template>
  <div id="myApp">
    <UserNav></UserNav>
    <router-view/>
  </div>
</template>

<script>
import UserNav from './components/UserNav'
export default {
  name: 'App',
  components: {UserNav}
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
