<template>
  <div>
    <div class="row">
      <div id="overlay">
        <!-- <img :src="imageFile" style="position:absolute; top:0; left:0;"> -->
        <div id="overin" :style="{ backgroundImage: 'url(\'' + imageFile + '\')' }"></div>
      </div>
    </div>
      <div class="row">
        <q-btn-toggle
        v-model="selectedColor"
        toggle-color="primary"
        push
        glossy
        :options="buttonColors"
      ></q-btn-toggle> {{ selectedColor }}
    </div>
  </div>
</template>

<script>
import { posterize } from 'potrace';
import imagetracer_v126 from 'imagetracerjs';

export default {
  name: 'PageIndex',

  data() {
    return {
      imageFile: require("../assets/451542_16.jpg"),
      titlea: 'Misco',
      svg: '',
      dictColors: {},
      dictColorsIndex: [],
      buttonColors: [],
      selectedColor: ""
    };    
  },
  watch: {
    selectedColor: function (newColor, oldColor){
      if (oldColor){
        let oldElements = document.querySelectorAll('[blockColorCode="'+ oldColor +'"][blockColorPainted=false]')
        for (let element of oldElements){
          this.unselectElement(element)
        }
      }
      let newElements = document.querySelectorAll('[blockColorCode="'+ newColor +'"][blockColorPainted=false]')
      for (let element of newElements){
        this.selectElement(element)
      }
    }
  },
  methods: {
    unselectElement: function(element){
      element.setAttribute("fill", "rgb(255,255,255)")
      element.setAttribute("stroke", "rgb(255,255,255)")
      element.removeEventListener('click', this.onClickBlockEvent)
    },
    selectElement: function(element){
      element.setAttribute("fill", "rgb(192,192,192)")
      element.setAttribute("stroke", "rgb(192,192,192)")
      element.addEventListener('click', this.onClickBlockEvent)
    },
    onClickBlockEvent: function(event){
      console.log("------>>>>>>> click")
      let element = event.target
      element.setAttribute("opacity", 0)
      element.setAttribute("blockColorPainted", true)
      'use strict';
      element.removeEventListener('click', this.onClickBlockEvent)
    },
    loadSvg: function(svgTxt){
      let element = document.getElementById("overin")
      element.innerHTML = svgTxt
      let childNodes = element.children[0].children
      for (let i=0; i<childNodes.length; i++){
        let childNode = childNodes[i]
        childNode.setAttribute("blockId", i)
        let color = childNode.attributes["fill"].value
       childNode.setAttribute("blockColorCode", color)
        childNode.setAttribute("blockColorPainted", false)
        if (!this.dictColors[color]){
          this.dictColors[color] = []
          this.dictColorsIndex.push(color)
        }else{
          this.dictColors[color].push(i)
        }
        childNodes[i].setAttribute("fill", "rgb(255,255,255)")
        childNodes[i].setAttribute("stroke", "rgb(255,255,255)")
      }
      this.initButtonColors()
    },
    initButtonColors: function(){
      let result = []
      for (let i=0; i<this.dictColorsIndex.length; i++){
        let item = {
          label: i+1,
          value: this.dictColorsIndex[i]
        }
        result.push(item)
      }
      this.buttonColors = result
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
<style>

</style>
