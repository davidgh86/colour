<template>
  <div class="container">
    <div class="large-12 medium-12 small-12 cell">
      <label>File
        <input type="file" id="file" ref="file" v-on:change="handleFileUpload()"/>
      </label>
      <button v-on:click="submitFile()">Submit</button>
      <img v-if="file" :src="filePath"/>
    </div>
  </div>
</template>

<script>
  const fs = require('fs');
  export default {
    data(){
      return {
        file: '',
        filePath: ''
      }
    },

    methods: {
      /*
        Submits the file to the server
      */
      submitFile(){
        let formData = new FormData();

        formData.append('file', this.file);

        this.$axios.post( '/api/upload',
            formData,
            {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
          }
        ).then((response)=>{
          this.$router.push({name:'color', params:{ id: response.data }});
        })
        .catch((error) => {
          console.log(error);
        });
      },

      /*
        Handles a change on the file upload
      */
      handleFileUpload(){
        this.file = this.$refs.file.files[0];
        this.filePath = URL.createObjectURL(this.file);
      }
    }
  }
</script>