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
      <q-btn color="primary" label="Switch lines" v-on:click="switchLines"></q-btn>
      <q-btn color="primary" label="New photo" v-on:click="goToIndex"></q-btn>
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
      photo: false,
      lines: true
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
    getLineElements(){
      return document.querySelectorAll('[blockColorCode="rgb(0,0,0)"]')
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
          childNode.setAttribute("fill", "rgb(255,255,255)")
          childNode.setAttribute("stroke", "rgb(255,255,255)")
        } else {
          if (!this.lines){
            childNode.setAttribute("opacity", 0)
          }
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
      if (this.photo == true){
        this.setCartoon()
      }else {
        this.setPhoto()
      }
    },
    switchLines: function(){
      let lineElements = this.getLineElements()
      let opacity = this.lines?0:1
      for (let element of lineElements){
        element.setAttribute("opacity", opacity)
      }
      this.lines=!this.lines
    },
    setCartoon: function(){
      this.imageFile = "/api/cartoon/"+this.imageUid
      this.photo = false
    },
    setPhoto: function(){
      this.imageFile = "/api/photo/"+this.imageUid
      this.photo = true
    },
    goToIndex: function(){
      this.$router.push('/')
    }
  },
  created () {
    console.log('2 - created')
  },
  beforeMount () {
    let imageId = this.$route.params.id
    this.imageUid = imageId

    this.setCartoon()

    this.$axios.get("/api/svg/"+imageId).then(response => {
      this.loadSvg(response.data)
    })
  }
}
</script>
<style>

</style>
