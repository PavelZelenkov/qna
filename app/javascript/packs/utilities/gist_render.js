function insertGist($container, url) {
  let scriptUrl = url.trim();
  if (!scriptUrl.endsWith('.js')) {
    if (scriptUrl.endsWith('/')) {
      scriptUrl = scriptUrl.slice(0, -1);
    }
    scriptUrl += '.js';
  }
  $container.empty();
  const script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = scriptUrl;
  $container[0].appendChild(script);
}

$(document).on('turbo:load', function() {
  $('.gist-container').each(function() {
    const $container = $(this);
    const url = $container.data('gist-url');
    if (url) {
      insertGist($container, url);
    }
  });
});
