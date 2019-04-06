<template>
    <div class="root-template">
        <h3>rules</h3>
        <ul class="rules">
            <li v-for="rule in rules">
                <span v-for="adjectives in rule.adjectives">
                    <span class="condition">{{adjectives.predicate}}</span>
                </span>
                <span> {{rule.subject}} </span>
                <span v-for="(condition, c) in rule.conditions">
                    <span v-if="c > 0"> and </span>
                    <span class="condition">{{condition.predicate}}
                        <span v-for="(subject, s) in condition.subjects">
                            <span v-if="s > 0"> & </span>
                            {{subject}}<!--
                        --></span><!--
                    --></span>
                </span>
                <span> {{rule.action}}</span>
            </li>
        </ul>
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
        computed: {
            rules: function () {
                if (!this.features) {
                    return [];
                }

                return this.features.array.map(feature => {
                    const featureArr = feature.array;
                    const ruleArr = featureArr[0].array;

                    return {
                        adjectives: featureArr[1].array
                            .filter(condition => condition.array[0] === 'lonely')
                            .map(condition => ({
                                predicate: condition.array[0]
                            })),
                        subject: ruleArr[0],
                        conditions: featureArr[1].array
                            .filter(condition => condition.array[0] !== 'lonely')
                            .map(condition => ({
                                predicate: condition.array[0],
                                subjects: condition.array[1].array
                            })),
                        action: ruleArr.slice(1).join(' ')
                    };
                })
            }
        }
    }
</script>

<style scoped>
    .rules {
        list-style-type: none;
    }
    .condition {
        text-decoration: underline;
    }
</style>
