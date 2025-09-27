export function csrfToken() {
  const meta = document.querySelector('meta[name="csrf-token"]');
  return meta && meta.content;
}

export async function postJSON(url, payload) {
  const resp = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": csrfToken(),
      "X-Requested-With": "XMLHttpRequest"
    },
    body: JSON.stringify(payload),
    credentials: "same-origin"
  });
  return resp;
}
