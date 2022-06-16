<script setup lang="ts">
import { ref } from 'vue'
import {
  BlogCreate,
  BlogUpdate,
  BlogId,
  listBlog,
  getBlog,
  createBlog,
  updateBlog,
  deleteBlog
} from '../apis/blog'

type Blog = BlogUpdate & {
  isEditing: boolean
}

const blogList = ref<Blog[]>([])
const newBlog = ref<BlogCreate>({
  title: '',
  content: ''
})

async function onCreateBlog() {
  await createBlog(newBlog.value)
  loadBlogList()
}

async function loadBlogList() {
  const data = await listBlog()
  blogList.value = data.map((blog) => ({
    ...blog,
    isEditing: false
  }))
}

loadBlogList()
</script>

<template>
  <div>
    <div v-for="blog of blogList" :key="blog.id">
      <h2>{{ blog.title }}</h2>
      <div>{{ blog.content }}</div>
    </div>
  </div>

  <div>
    <input v-model="newBlog.title" placeholder="title" />
    <input v-model="newBlog.content" placeholder="content" />
    <button @click="onCreateBlog">Create</button>
  </div>
</template>

<style></style>
