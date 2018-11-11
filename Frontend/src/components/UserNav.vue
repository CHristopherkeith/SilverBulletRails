<template>
	<div class="userNav">
		<!-- <div class="userNavtitle">{{parentMenu.title}}</div> -->
		<div class="userNavtitle"><router-link :to="parentMenu.path">{{parentMenu.title}}</router-link></div>
		<ul>
			<!-- <template v-for="item in childMenu">
				<li>{{item.title}}</li>
			</template> -->
			<li v-for="item in childMenu"><router-link :to="item.path">{{item.title}}</router-link></li>
		</ul>
	</div>
</template>
<script type="text/javascript">
	export default{
		name: 'UserNav',
		props: ['parentMenu', 'childMenu'],
		data(){
		return{
			// parentMenu:{
			// 	title: 'Hello',
			// 	path: 'Hello'
			// },
			// childMenu:[
			// 	{
			// 		title: 'Login',
			// 		path: 'Login'
			// 	},
			// 	{
			// 		title: 'Register',
			// 		path: 'Register'
			// 	},
			// ]
		}
		},
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