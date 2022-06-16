import { useFetch } from '@vueuse/core'

const get = async <T>(url: string): Promise<T> => {
  const { data } = await useFetch(url).get().json()
  return data.value
}

const post = async (url: string, postData: any) => {
  const { data } = await useFetch(url).post(postData).json()
  return data.value
}

const put = async (url: string, postData: any) => {
  const { data } = await useFetch(url).put(postData).json()
  return data.value
}

const del = async (url: string) => {
  const { data } = await useFetch(url).delete().json()
  return data.value
}

type Blog = {
  id: number
  title: string
  content: string
}
export type BlogCreate = Omit<Blog, 'id'>
export type BlogUpdate = Blog
export type BlogId = Pick<Blog, 'id'>

export const listBlog = () => get<BlogUpdate[]>('/api/blog')

export const getBlog = (id: BlogId) => get(`/api/blog/${id}`)

export const createBlog = (data: BlogCreate) => post('/api/blog', data)

export const updateBlog = (id: BlogId, data: BlogUpdate) =>
  put(`/api/blog/${id}`, data)

export const deleteBlog = (id: BlogId) => del(`/api/blog/${id}`)
