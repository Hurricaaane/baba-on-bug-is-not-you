<template>
    <div class="root-template">
        <h2 v-bind:key="i1" v-for="(v1,i1) in features.array">
            <!--<div v-bind:key="i2" v-for="(v2,i2) in v1.array">-->
            <span v-bind:key="i3" v-for="(v3,i3) in v1.array[0].array">
                    {{ v3 }}
                </span>
            <!--</div>-->
        </h2>
    </div>
</template>

<script>
    export default {
        name: 'FeatureViewer',
        props: {
            features: {}
        },
        data: function () {
            return {}
        },
    }
</script>

<style scoped>
</style>
