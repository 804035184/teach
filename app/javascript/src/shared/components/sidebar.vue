<template>
  <div
    class="sidebar"
    :style="{height: totalHeight + 'px', width: totalWidth + 'px'}">
    <div
      v-if="divider"
      v-on:mousedown="drag"
      class="divider"
      :style="{height: totalHeight + 'px'}">
    </div>
    <div class="detail">
      <detail-issue :issue="detailIssue" :issue-dup="rawIssue"></detail-issue>
    </div>
  </div>
</template>
<script>
  import DetailIssue from './detail_issue.vue'
  import eventhub from '../../issues/eventhub'
  import Issue from '../../issues/models/issue'

  export default {
    components: {
      DetailIssue
    },
    data() {
      return {
        dragable: false,
        preX: 0,
      }
    },
    props: {
      detailIssue: Issue,
      rawIssue: Issue,
      totalHeight: Number,
      totalWidth: Number,
      detailIndex: Number,
      divider: Boolean
    },
    computed: {

    },
    methods: {
      drag(src) {
        this.preX = src.clientX;
        this.dragable = true;
        let mousemoveCb = (des) => {
          des = des || event;
          this.updateWidth(des);
          document.removeEventListener('mousemove', mousemoveCb);
          setTimeout(() => {
            document.addEventListener('mousemove', mousemoveCb);
          }, 30);
        };
        document.addEventListener('mousemove', mousemoveCb);
        let mouseupCb = (des) => {
          des = des || event;
          this.updateWidth(des);
          this.dragable = false;
          document.removeEventListener('mousemove', mousemoveCb);
          document.removeEventListener('mouseup', mouseupCb);
        };
        document.addEventListener('mouseup', mouseupCb);
      },
      updateWidth(des) {
        if (!this.dragable) {
          return;
        }
        let diff = des.clientX - this.preX;
        this.preX = des.clientX;
        eventhub.$emit('updateAsideWidth', diff);
      }
    }
  }
</script>
<style scoped>
  .sidebar {
    overflow: auto;
    border-bottom: 1px solid #e5e5e5;
    display: flex;
  }
  .divider {
    width: 15px;
    position: relative;
    left: -10px;
    cursor: col-resize;
    background-color: #fff;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    /*兼容 IE*/
    border-bottom: 1px solid #e5e5e5;
  }

  .detail {
    min-width: 300px;
    flex: 1;
  }
</style>