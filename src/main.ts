import './assets/main.css'
import 'vuetify/styles'
import { createApp } from 'vue'
import {createVuetify} from 'vuetify'
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";
import App from './App.vue'

const vuetify = createVuetify({
  // Your Vuetify configuration options
    components,
    directives,
    theme: {
        defaultTheme: 'dark'
    }
});


createApp(App).use(vuetify).mount('#app')
