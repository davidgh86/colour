<template>
  <q-page class="flex flex-center">
    <div id="overlay">
      <img
        :src="imageFile"
      >
    </div>
    <div v-html="svg" styel="z-index: 9;" id="overin"></div>
  </q-page>
</template>

<script>
import { posterize } from 'potrace';
import imagetracer_v126 from 'imagetracerjs';

export default {
  name: 'PageIndex',

  data() {
    return {
      imageFile: "img/451542_16.jpg",
      titlea: 'Misco',
      svg: '',
      dictColors: {}
    };    
  },
  methods: {
    getThresholds: function(num){
      let step = 256 / num
      
      let result = []

      for (i=step; i<256; i=i+step){
          result.push(i)
      }
      return result;
    },
    loadSvg: function(svgTxt){
      let element = document.getElementById("overin")
      element.innerHTML = svgTxt
      // element.children[0].addEventListener("click", (event)=> {
      //   alert("hola")
      // })
      let childNodes = element.children[0].children
      for (let i=0; i<childNodes.length; i++){
        let childNode = childNodes[i]
        childNode.setAttribute("blockId", i)
        if (!this.dictColors[childNode.attributes["fill"].value]){
          this.dictColors[childNode.attributes["fill"].value] = []
        }else{
          this.dictColors[childNode.attributes["fill"].value].push(i)
          
        }
        childNodes[i].attributes["fill"].value = "rgb(255,255,255)"
        childNodes[i].attributes["stroke"].value = "rgb(255,255,255)"
      }
      document.getElementById("overin").addEventListener("click", (event)=>{
        if (!event.target.attributes["opacity"] || event.target.attributes["opacity"].value!=0){
          event.target.attributes["opacity"].value = 0
          event.target.preventDefault()
        }
      })
    }
  },
  created () {
    console.log('2 - created')
  },
  beforeMount () {
    imagetracer_v126.imageToSVG(this.imageFile, this.loadSvg, {numberofcolors : 16, mincolorratio:20})
  }
}
</script>
<style scoped>
#overlay{
  position: fixed;
  margin-left: auto; 
  margin-right: auto; /* HORIZONTAL CENTER */
}
#overin {
  margin-left: auto; 
  margin-right: auto; /* HORIZONTAL CENTER */
  z-index: 2;
}
</style>
