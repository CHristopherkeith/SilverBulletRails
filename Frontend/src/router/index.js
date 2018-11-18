import Vue from 'vue'
import Router from 'vue-router'
// import HelloWorld from '@/components/HelloWorld'
import ExactAiming from '@/components/ExactAiming'
import PressReaction from '@/components/PressReaction'
import Login from '@/components/Login'
import Register from '@/components/Register'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      // name: 'ExactAiming',
      component: ExactAiming
    },
    {
      path: '/exactaiming',
      // name: 'ExactAiming',
      component: ExactAiming
    },
    {
      path: '/pressreaction',
      // name: 'PressReaction',
      component: PressReaction
    },
    {
      path: '/login',
      component: Login,
      props: { login: true }
    },
    {
      path: '/register',
      component: Login,
      props: { login: false }
    },
  ]
})
