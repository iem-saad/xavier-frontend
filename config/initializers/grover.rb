Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '5px',
      bottom: '10cm'
    },
    prefer_css_page_size: true,
    emulate_media: 'screen',
    bypass_csp: true,
    media_features: [{ name: 'prefers-color-scheme', value: 'dark' }],
    vision_deficiency: 'deuteranopia',
    extra_http_headers: { 'Accept-Language': 'en-US' },
    cache: false,
    timeout: 0, # Timeout in ms. A value of `0` means 'no timeout'
    launch_args: ['--font-render-hinting=medium'],
    wait_until: 'domcontentloaded'
  }
  config.use_png_middleware = true
  config.use_jpeg_middleware = true
  config.use_pdf_middleware = false
  config.root_url = 'http://localhost:3000/'
end