<template>
  <div class="video-list">
    <v-card class="pa-4">
      <template v-slot:title>
        <span>视频列表</span>
      </template>
      <v-list>
        <v-list-item v-for="(v, idx) in videos" :key="idx" @click="selectVideo(idx)" style="cursor: pointer;">
          <v-list-item-avatar>
            <v-img :src="v.thumb"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-list-item-title>{{ v.title }}</v-list-item-title>
            <v-list-item-subtitle>{{ v.desc }}</v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-action>
            <v-icon>mdi-play-circle</v-icon>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </v-card>
  </div>
</template>

<script>
export default {
  name: 'VideoList',
  props: {
    videos: { type: Array, default: () => [] }
  },
  methods: {
    selectVideo(idx){
      this.$emit('select', idx);
    }
  }
}
</script>

<style scoped>
.video-list { max-width: 720px; }
</style>