<template>
  <div class="exactAimingMask" v-show="maskShow">
    <p class="instructions">
      userAddress: <span>{{userAddress}}</span>
      <br>
      Game duration: <span>{{duration}}</span> sec.
      <br>
      Hit: <span>{{hitsPoint > 0 ? `+${hitsPoint}` : hitsPoint}}</span> pts
      <br>
      Miss: <span>{{missesPoint > 0 ? `+${missesPoint}` : missesPoint}}</span> pts
      <br>
      Left target: <span>{{missesTgtPoint > 0 ? `+${missesTgtPoint}` : missesTgtPoint}}</span> pts
    </p>
    <p class="clickText" :class="{alertCls: alertClsValue&&false}" @click.stop="triggerStart()" v-show="!confirmStatus">{{maskText}}</p>
    <p class="clickText" v-show="confirmStatus">NEW RECORD!SAVE?<span class="confirmRecordYes" @click="confirmRecord(true)">YES</span>/<span class="confirmRecordNo" @click="confirmRecord(false)">NO</span></p>
  </div>
</template>

<script>
import { mapMutations } from 'vuex'
import { mapState } from 'vuex'
export default {
  name: 'ExactAimingMask',
  // components: {TheTarget},
  props: ['maskShow', 'maskText', 'duration', 'confirmStatus'],
  data () {
    return {
      // alertClsValue: false
    }
  },
  // mapState方式
  // computed: mapState({
  //   hasWalletExt: state => state.hasWalletExt,
  //   userAddress: state => state.userAddress,
  //   alertClsValue(state){
  //     return !state.hasWalletExt;
  //   }
  // }),
  // 混入方式
  computed: {
    ...mapState([
      'hasWalletExt',
      'userAddress',
      'hitsPoint',
      'missesPoint',
      'missesTgtPoint',
      'durationValue'
    ]),
    // ...mapState({
    //   'userAddress1': 'userAddress',
    // }),
    alertClsValue(){
      return !this.$store.state.hasWalletExt;
    }
  },
  methods: {
    triggerStart(e){
      this.axios.get('/silver_bullets/game_initialize', {params: {cnt: this.durationValue}})
      .then(
        res=>{
          if(res.data.success){
            this.$emit('update:maskShow', false);
            this.$emit('trigger:exactAimingStart', res.data.data.initial_position);
          }else{
            alert('初始化游戏出现错误：' + res.data.msg);
          }
        },
        err=>{
          alert('初始化游戏出现错误:(');
        }
      )
    },
    confirmRecord(confirmFlag){
      if(confirmFlag){
        this.$store.dispatch('VERIFY_SCORE', {})
        .then(
          res => {
            console.log(res.data, '【VALIDATE_SCORE res】')
            if(res.data.success){
              console.log('res success')
              // ////////////////
              if(!this.hasWalletExt){
                alert('Please Install WebExtensionWallet First');
                return;
              }
              this.$store.dispatch('SAVE_STORE', {
                type: 'exact'
              })
              .then(
                res => {
                  this.$store.commit('CHANGE_LOADING_MASK', {
                    loadingMaskShow: false
                  })
                  if(res.status === 1){
                    console.log('【success】')
                    this.$store.commit('SET_SCORE', {
                      exactScore: this.$store.state.now.score,
                      exactMisses: this.$store.state.now.misses,
                      exactMissesTgt: this.$store.state.now.missesTgt,
                      pressScore: 0,
                      pressMisses: 0,
                      pressMissesTgt: 0,
                    })
                  }else{
                    alert(res.execute_result)
                    console.log('【fail】')
                  }
                },
                err => {
                  this.$store.commit('CHANGE_LOADING_MASK', {
                    loadingMaskShow: false
                  })
                  alert(err.execute_result)
                  console.log(err, '【err confirmRecord】')
                }
              )
            }else{
              if(res.data.redirect){
                console.log('【redirect】')
                // console.log(this, '【this】')
                this.$router.push({path: res.data.redirect})
              }else{
                alert('出现错误：' + res.data.msg);
              }
            }
          },
          err => {
            console.log(err, '【VALIDATE_SCORE err】')
            if(err.data&&err.data.msg){
              alert('出现错误：' + err.data.msg);
            }else{
              alert('出现错误！')
            }
          }
        )
        
        this.$emit('update:confirmStatus', false);
      }else{
        this.$emit('update:confirmStatus', false);
      }
    }
  },
  // computed: mapState([
  //   'score',
  // ]),
  mounted: function(){

  }
}
</script>

<style scoped>
  .exactAimingMask{
    position: relative;
  }
  .exactAimingMask>p.clickText{
    cursor: pointer;
    color: #79B6E8;
    text-align: center;
    user-select: none;
    letter-spacing: 5px;
    position: absolute;
    margin: auto;
    padding: auto;
    top: 0px;
    bottom: 0px;
    left: 0px;
    right: 0px;
    width: 100%;
    height: 20px;
  }
  .alertCls{
    color: red !important;
  }
  .exactAimingMask>p.instructions{
    position: absolute;
    width: 155px;
    top: 5px;
    left: 5px;
    font-size: 13px;
    line-height: 17px;
    color: #788290;
  }
  .exactAimingMask>p.instructions>span{
    color: white;
  }
  .confirmRecordYes{
    font-size: 30px;
    font-weight: bolder;
    transition:all 0.5s;
  }
  .confirmRecordYes:hover{
    color: #ffffff;
  }
  .confirmRecordNo{
    font-weight: bolder;
    transition:all 0.5s;
  }
  .confirmRecordNo:hover{
    color: gray;
  }
</style>
