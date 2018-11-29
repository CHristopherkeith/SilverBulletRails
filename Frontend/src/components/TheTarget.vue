<template>
  <div class="thetarget" @click.stop="clickTarget" :style="{left: left+'px', top: top+'px'}" :class="{clickCls: isClick}">
  </div>
</template>

<script>
import {mapState} from 'vuex'
export default {
  name: 'TheTarget',
  props: ['left', 'top'],
  data () {
    return {
      isClick: false
    }
  },
  computed:{
    ...mapState(['startTime']),
  },
  methods: {
    clickTarget(e){
      console.log(e, '【e】')
      this.isClick = true;
      let scaleFactorMathcRes, scaleFactor, width, height;
      width = this.$el.offsetWidth;
      height = this.$el.offsetHeight;
      scaleFactorMathcRes = window.getComputedStyle(this.$el).getPropertyValue('transform').match(/matrix\((.+)\)/i);
      console.log(this.left, this.top)
      if(scaleFactorMathcRes){
        scaleFactor = scaleFactorMathcRes[1].split(',')[0];
        this.$emit('add:clickMask', {
          left: this.left+20*(1-scaleFactor),
          top: this.top+20*(1-scaleFactor),
          width:width*scaleFactor,
          height:height*scaleFactor
        });
      }
      this.$el.parentNode.removeChild(this.$el);
      console.log(this.startTime)
      this.$emit('addScore', [new Date() - this.startTime, this.left, this.top]);
    }

  }
}
</script>

<style scoped>
  .clickCls{
    background-color: gray !important;
  }
  .thetarget{
    /*background: url(../assets/img/inu.jpg) no-repeat center center;
    background-size: 100% 100%;*/
  }
</style>
