<script setup lang="ts">
    import "leaflet/dist/leaflet.css"
    import * as L from 'leaflet';
    import {computed, onMounted, ref} from 'vue'

    const props = defineProps({
        mapWidthPercentage: {type: Number, default: 50}, 
        mapHeightPercentage: {type: Number, default: 50},
        mapCenterLatitude: {type: Number, default: 38.7946},
        mapCenterLongitude: {type: Number, default: 106.5348},
        defaultZoom: {type: Number, default: 16},
        singleMarker: {type:Boolean, default: false}
    });

    const emit = defineEmits([
        'markerAdded'
    ]);

    const mapWidth = computed(() => {
        return `${props.mapWidthPercentage}vw`
    });

    const mapHeight = computed(() => {
        return `${props.mapHeightPercentage}vh`
    });

    const centerCoordinates = computed(() => {
        return new L.LatLng(props.mapCenterLatitude, props.mapCenterLongitude)
    });


    let componentMap: L.Map | L.LayerGroup<any>;

    
    const map_markers= ref<number[][]>([])


    function addPointToMap(evt: L.LeafletMouseEvent){
        
        let selected_coordinates: [number, number][] = [[evt.latlng.lat, evt.latlng.lng]]

        L.marker(evt.latlng)

        if(props.singleMarker == true){
            if (map_markers.value.length > 0) {
                map_markers.value = []
            }
        }

        map_markers.value.push([evt.latlng.lat, evt.latlng.lng])

        emit("markerAdded", selected_coordinates)

    }

    onMounted(() => {
      setupMap()  
    })

    function setupMap(){
        componentMap = L.map('map').setView(centerCoordinates.value, props.defaultZoom);
        
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19, 
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        }).addTo(componentMap);     
    }

</script>

<template>
    <div class="map-container" id="map"></div>
</template>

<style scoped>
    .map-container {
        width: v-bind(mapWidthPercentage);
        height: v-bind(mapHeightPercentage);
    }
</style>