<script setup lang="ts">
    import CatchMap from './CatchMap.vue';
    import type { MapMarkerAddedResult } from '@/types/index';
    import { ref } from 'vue';
    import { VContainer, VRow, VCol } from 'vuetify/components';
    import { VSelect, VTextField, VForm, VBtn } from 'vuetify/components';
    import { VFileUpload } from 'vuetify/labs/VFileUpload';

    const selected_latitude = ref<Number | any>(null)
    const selected_longitude = ref<Number | any>(null)
    const selected_catch_date = ref()
    const selected_catch_weight = ref()
    const selected_water_temperature = ref()
    const selected_water_depth = ref()
    const selected_air_temperature = ref()
    const selected_species = ref()
    const selected_sky = ref()
    const selected_technique = ref()
    const selected_bait = ref()

    function handleMarkerAdded(coordinates: MapMarkerAddedResult){
        
        selected_latitude.value = coordinates.latitude
        selected_longitude.value = coordinates.longitude

    }

</script>

<template>

    <v-container>
        <v-row>
            <v-col>
                <v-row>
                    <v-col>
                        <CatchMap :single-marker=true :map-height-percentage=50 :map-width-percentage=40
                            :default-zoom=10 :map-center-latitude=38.820411 :map-center-longitude=-77.429642 
                            @marker-added="handleMarkerAdded"/>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <v-file-upload title="Upload Catch Image" clearable density="compact"></v-file-upload>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <v-btn class="cancel-btn">Cancel</v-btn>
                        <v-btn class="save-btn">Save</v-btn>
                        <v-btn class="save-continue-btn">Save and Add Another</v-btn>
                    </v-col>
                </v-row>
            </v-col>

            <!-- Form Fields-->
            <v-col>  
                <!--Form-->
                <v-form @submit.prevent>
                    <!-- Latitude -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_latitude" disabled label="Latitude:"
                                variant="outlined">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Longitude -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_longitude" disabled label="Longitude:"
                                variant="outlined">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Catch Date -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field type="date" class="form-control" density="compact" 
                                v-model="selected_catch_date" label="Catch Date:"
                                variant="outlined">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Species -->
                    <v-row no-gutters>
                        <v-col>
                            <v-select label="Species:"  class="form-control" v-model="selected_species" 
                                density="compact" variant="outlined" clearable>
                            </v-select>    
                        </v-col>
                    </v-row>

                    <!-- Weight -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_catch_weight" label="Catch Weight (lbs):"
                                variant="outlined" type="number" step="0.1">
                            </v-text-field>    
                        </v-col>
                    </v-row>
                    
                    <!-- Water Temperature -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_water_temperature" label="Water Temperature (F):"
                                variant="outlined" type="number">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Air Temperature -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_air_temperature" label="Air Temperature (F):"
                                variant="outlined" type="number">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Water Depth -->
                    <v-row no-gutters>
                        <v-col>
                            <v-text-field class="form-control" density="compact" 
                                v-model="selected_water_depth" label="Water Depth (Feet):"
                                variant="outlined" type="number">
                            </v-text-field>    
                        </v-col>
                    </v-row>

                    <!-- Sky -->
                    <v-row no-gutters>
                        <v-col>
                            <v-select label="Sky Conditions:"  class="form-control" v-model="selected_sky" 
                                density="compact" variant="outlined" clearable>
                            </v-select>                               
                        </v-col>
                    </v-row>

                    <!-- Technique -->
                    <v-row no-gutters>
                        <v-col>
                            <v-select label="Technique:"  class="form-control" v-model="selected_technique" 
                                density="compact" variant="outlined" clearable>
                            </v-select>                               
                        </v-col>
                    </v-row>

                    <!-- Technique -->
                    <v-row no-gutters>
                        <v-col>
                            <v-select label="Bait:"  class="form-control" v-model="selected_bait" 
                                density="compact" variant="outlined" clearable>
                            </v-select>                               
                        </v-col>
                    </v-row>



                </v-form>
            </v-col>

        </v-row>

    </v-container>

</template>

<style scoped>

    .form-control
    {
        color: chartreuse;
        font-weight: 900;
    }

    .cancel-btn
    {
        color: orange;
        margin-right: 3px;
    }

    .save-btn
    {
        color: chartreuse;
        margin-right: 3px;
    }

    .save-continue-btn
    {
        color: aqua;
    }

</style>