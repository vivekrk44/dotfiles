vim.filetype.add({
  pattern = {
    ['Dockerfile_*'] = 'dockerfile',
    ['Dockerfile.*'] = 'dockerfile',
  },
  filename = {
    ['Containerfile'] = 'dockerfile',
  },
})
