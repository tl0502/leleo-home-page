<template>
  <div class="video-player">
    <v-card class="pa-4">
      <template v-slot:title>
        <span>{{ current?.title || '播放' }}</span>
      </template>
      <div style="display:flex;flex-direction:column;gap:12px;">
        <video ref="player" :src="current?.src" controls autoplay style="width:100%;max-height:60vh;background:#000"></video>
        <div style="display:flex;justify-content:space-between;align-items:center;">
          <div>
            <v-btn icon @click="prev" :disabled="currentIndex<=0"><v-icon>mdi-skip-previous</v-icon></v-btn>
            <v-btn icon @click="togglePlay"><v-icon>{{ playing ? 'mdi-pause' : 'mdi-play' }}</v-icon></v-btn>
            <v-btn icon @click="next" :disabled="currentIndex>=videos.length-1"><v-icon>mdi-skip-next</v-icon></v-btn>
          </div>
          <div>
            <v-btn small variant="tonal" @click="$emit('close')">关闭</v-btn>
          </div>
        </div>
      </div>
    </v-card>
  </div>
</template>

<script>
export default {
  name: 'VideoPlayer',
  props: {
    videos: { type: Array, default: () => [] },
    currentIndex: { type: Number, default: 0 }
  },
  data(){
    return { playing: true }
  },
  computed: {
    current(){
      return this.videos[this.currentIndex] || null;
    }
  },
  mounted(){
    this.$refs.player.addEventListener('play', ()=> this.playing = true);
    this.$refs.player.addEventListener('pause', ()=> this.playing = false);
  },
  methods: {
    togglePlay(){
      const p = this.$refs.player;
      if(p.paused) p.play(); else p.pause();
    },
    prev(){
      this.$emit('change', Math.max(0, this.currentIndex-1));
    },
    next(){
      this.$emit('change', Math.min(this.videos.length-1, this.currentIndex+1));
    }
  }
}
</script>

<style scoped>
.video-player { max-width: 900px; }
</style>