<template>
    <div class="root-template">
        <div class="container">
            <div class="row">
                <div class="col-6">
                    <div class="card">
                        <div class="card-body">
                            <FeatureViewer v-bind:features="mergedData.features" />
                        </div>
                    </div>
                </div>
                <div class="col-6"  v-if="mergedData.units">
                    <div class="log" v-for="unit in mergedData.units.array" v-bind:style="{ position: 'absolute',
                            left: unit.vXPOS * 20 + 'px',
                            top: unit.vYPOS * 20 + 'px',
                            'font-size': '' + '0.7em',
                            transform: 'rotate(10deg)'
                             }">
                        {{unit.sUNITNAME}}
                    </div>
                    <!--{{mergedData.units.array.map(u => u.strings_UNITNAME)}}-->
                </div>
            </div>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <!--<div class="row">-->
                <!--<div class="logs">-->
                    <!--<div class="log" v-bind:key="index" v-for="(bit,index) in bits">{{ bit }}</div>-->
                <!--</div>-->
            <!--</div>-->
        </div>
    </div>
</template>

<script>
    import FeatureViewer from './FeatureViewer.vue'

    export default {
        name: 'BabaViewer',
        components: {
            FeatureViewer
        },
        props: {},
        data: function () {
            return {
                ws: undefined,
                destroying: false,
                lastData: "",
                bits: [],
                mergedData: {}
            }
        },
        created: function () {
            this.doStartWs();
        },
        beforeDestroy() {
            this.destroying = true;
            if (this.ws) {
                this.ws =
                    this.ws.close();
            }
        },
        methods: {
            doStartWs: function () {
                try {
                    const ws = new WebSocket('ws://localhost:7777/ws');
                    ws.onopen = () => {
                    };
                    ws.onmessage = event => {
                        this.onDataReceived(event.data)
                    };
                    ws.onclose = () => {
                        this.restartWs();
                    };
                    ws.onerror = err => {
                        ws.close();
                        throw err;
                    };
                    this.ws = ws;

                } catch (err) {
                    this.restartWs();
                }
            },
            restartWs: function () {
                delete this.ws;
                if (!this.destroying) {
                    setTimeout(() => {
                        this.doStartWs();
                    }, 1000);
                }
            },
            onDataReceived: function (data) {
                if (this.lastData !== data) {
                    this.lastData = data;
                    this.bits.push(data);
                    if (this.bits.length > 50) {
                        this.bits.shift();
                    }

                    const parsedData = JSON.parse(data);
                    Object.assign(this.mergedData, parsedData);
                    this.$forceUpdate();
                }
            }
        }
    }
</script>

<style scoped>
    .logs {
        font-size: 0.8em;
        font-family: monospace;
    }
    .log {
        border-bottom: 1px solid lightgray;
    }
</style>
