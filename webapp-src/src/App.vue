<template>
    <div id="app">
        <BabaViewer/>
    </div>
</template>

<script>
    import BabaViewer from './components/BabaViewer.vue'

    export default {
        name: 'app',
        components: {
            BabaViewer
        }
    }
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        /*text-align: center;*/
        color: #2c3e50;
        margin-top: 60px;
    }
</style>
