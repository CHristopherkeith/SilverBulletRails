<template>
  <div class="thetarget" @click.stop="clickTarget" :style="{left: left+'px', top: top+'px'}" :class="{clickCls: isClick}">
  </div>
</template>

<script>
import {mapState} from 'vuex'
export default {
  name: 'TheTarget',
  props: ['left', 'top', 'index'],
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
      this.isClick = true;
      let scaleFactorMathcRes, scaleFactor, width, height, screenLeft, screenTop;
      width = this.$el.offsetWidth;
      height = this.$el.offsetHeight;
      screenLeft = this.$el.offsetParent.offsetParent.offsetLeft;
      screenTop = this.$el.offsetParent.offsetParent.offsetTop;
      scaleFactorMathcRes = window.getComputedStyle(this.$el).getPropertyValue('transform').match(/matrix\((.+)\)/i);
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
      this.$emit('addScore', {time: new Date() - this.startTime, x: e.x-screenLeft-20, y: e.y-screenTop-20, hit:true, index:this.index});
    }

  }
}
</script>

<style scoped>
  .clickCls{
    background-color: gray !important;
  }
</style>
