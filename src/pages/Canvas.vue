<template>
  <div>
    <div class="row">
      <div id="overlay">
        <!-- <img :src="imageFile" style="position:absolute; top:0; left:0;"> -->
        <div id="overin" v-bind:style="{ 'background-image': 'url(\'' + imageFile + '\')' }"></div>
      </div>
    </div>
    <div class="row">
      <q-btn-toggle
      v-model="selectedColor"
      toggle-color="primary"
      push
      glossy
      :options="buttonColors"
    >
      </q-btn-toggle> {{ selectedColor }}
    </div>
    <div class="row">
      <q-btn color="primary" label="Paint" v-on:click="paintAll"></q-btn>
      <q-btn color="primary" label="Photo/Cartoon" v-on:click="switchPhoto"></q-btn>
    </div>
  </div>
</template>

<script>
// import { posterize } from 'potrace';
//import imagetracer_v126 from 'imagetracerjs';

export default {
  name: 'Canvas',

  data() {
    return {
      imageFile: "",
      imageUid: "",
      titlea: 'Misco',
      svg: '',
      dictColors: {},
      dictColorsIndex: [],
      buttonColors: [],
      selectedColor: "",
      type: "cartoon"
    };    
  },
  watch: {
    selectedColor: function (newColor, oldColor){
      if (oldColor){
        let oldElements = this.getNotPaintedBlocksByColor(oldColor)
        for (let element of oldElements){
          this.unselectElement(element)
        }
      }
      let newElements = this.getNotPaintedBlocksByColor(newColor)
      for (let element of newElements){
        this.selectElement(element)
      }
    }
  },
  methods: {
    getNotPaintedBlocksByColor(color){
      return document.querySelectorAll('[blockColorCode="'+ color +'"][blockColorPainted=false]')
    },
    unselectElement: function(element){
      element.setAttribute("fill", "rgb(255,255,255)")
      element.setAttribute("stroke", "rgb(255,255,255)")
      element.removeEventListener('click', this.onClickBlockEvent)
    },
    selectElement: function(element){
      element.setAttribute("fill", "rgb(255,255,0)")
      element.setAttribute("stroke", "rgb(255,255,0)")
      element.addEventListener('click', this.onClickBlockEvent)
    },
    onClickBlockEvent: function(event){
      let element = event.target
      this.colour(element)
    },
    colour: function(element){
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
        let color = childNode.getAttribute("fill")
        childNode.setAttribute("blockColorCode", color)
        if (color != "rgb(0,0,0)"){
          childNode.setAttribute("blockColorPainted", false)
          if (!this.dictColors[color]){
            this.dictColors[color] = []
            this.dictColorsIndex.push(color)
          }else{
            this.dictColors[color].push(i)
          }
          childNodes[i].setAttribute("fill", "rgb(255,255,255)")
          childNodes[i].setAttribute("stroke", "rgb(255,255,255)")
        } else {
          childNode.setAttribute("blockColorPainted", true)
        }
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
    },
    paintAll: async function() {
      // TODO fix this
      for (let i=0; i<this.dictColorsIndex.length; i++){
        this.selectedColor = this.dictColorsIndex[i]
        await this.paintByColour(this.dictColorsIndex[i])
      }
    },
    paintByColour: async function(color) {
      let blocksByColor = this.getNotPaintedBlocksByColor(color)
      setTimeout(()=> {
        for (let element of blocksByColor){
          this.colour(element)
        }
      }, 1000)
    },
    switchPhoto: function() {
      if (this.type == "cartoon"){
        this.imageFile = "http://localhost:5000/photo/"+this.imageUid
        this.type = "photo"
      }else {
        this.imageFile = "http://localhost:5000/cartoon/"+this.imageUid
        this.type = "cartoon"
      }
    }
  },
  created () {
    console.log('2 - created')
  },
  beforeMount () {
    let imageId = this.$route.params.id
    this.imageUid = imageId

    this.imageFile = "http://localhost:5000/cartoon/"+imageId
    this.type = "cartoon"

    this.$axios.get("svg/"+imageId).then(response => {
      this.loadSvg(response.data)
    })
  }
}
</script>
<style>

</style>
