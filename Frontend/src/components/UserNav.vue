<!-- 支持 navMethod和非navMethod动态传父组件方法 -->
<template>
	<div class="userNav">
		<!-- <div class="userNavtitle" @click="triggerEvent(parentMenu.method)"><router-link :to="parentMenu.path?parentMenu.path:''">{{parentMenu.title}}</router-link></div> -->
		<div class="userNavtitle" @click="triggerEvent(parentMenu.method)"><router-link :to="parentMenu.path?parentMenu.path:''">{{parentMenu.title}}</router-link></div>
		<ul>
			<!-- <template v-for="item in childMenu">
				<li @click="clickItem" data="444">{{item.title}}</li>
			</template> -->
			<li v-for="item in childMenu" @click="triggerEvent(item.method)"><router-link :to="item.path?item.path:''">{{item.title}}</router-link></li>
		</ul>
	</div>
</template>
<script type="text/javascript">
	export default{
		name: 'UserNav',
		props: ['parentMenu', 'childMenu', 'navMethod'],
		data(){
			return{

			}
		},
		methods:{
			triggerEvent(eventName){
				if(this.navMethod){
					if(typeof this.navMethod[eventName] === 'function'){
						this.navMethod[eventName]();
					}
				}else{
					if(this.$parent && typeof this.$parent[eventName] === 'function'){
						this.$parent[eventName]();
					}
				}
			}
		}
	}
</script>
<style scoped>
	.userNav{
		position: absolute;
		right: 10px;
		text-align: center;
		color: white;
		font-weight: bolder;
		z-index: 1000;
		user-select:none;
		width: 70px;
	}
	.userNav a:link, .userNav a:visited{
		text-decoration: none;
		color: white;
	}
	.userNav a:hover{
		color: #86c8ff;
	}
	.userNav>ul{
		display: none;
		list-style: none;
	}
	.userNav:hover>ul{
		display: block;
	}
	.userNav>ul>li, .userNavtitle{
		padding-top: 5px;
	}
	.userNav>ul>li:hover, .userNavtitle:hover{
		color: #86c8ff;
		cursor: pointer;
		border-bottom: 1px solid;
	}
</style>