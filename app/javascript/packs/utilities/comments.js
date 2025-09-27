import { postJSON } from "../../lib/csrf";

function setupCommentForm(form) {
  const listId   = form.dataset.listId;
  const url      = form.dataset.createUrl;
  const textarea = form.querySelector("textarea");
  const submit   = form.querySelector('input[type="submit"], button[type="submit"]');
  const list     = document.getElementById(listId);

  if (!list) { console.warn(`[comments] List element not found: #${listId}`); return; }


  const errorsBoxId = `${listId}-errors`;
  let errorsBox = document.getElementById(errorsBoxId);
  if (!errorsBox) {
    errorsBox = document.createElement("div");
    errorsBox.id = errorsBoxId;
    errorsBox.className = "comment-errors";
    list.after(errorsBox);
  }

  function showErrors(messages) {
    errorsBox.innerHTML = "";
    messages.forEach((msg) => {
      const p = document.createElement("p");
      p.textContent = msg;
      errorsBox.appendChild(p);
    });
  }

  const enableSubmit = () => {
    if (!submit) return;
    submit.removeAttribute("disabled");
    submit.removeAttribute("data-disable-with");
  };

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorsBox.innerHTML = "";
    submit?.setAttribute("disabled", "disabled");

    const body = textarea.value.trim();

    if (!body) {
      enableSubmit();
      try { showErrors(["Comment cannot be empty"]); } catch(_) {}
      return;
    }

    try {
      const resp = await postJSON(url, { comment: { body } });
      if (resp.ok) {
        const json = await resp.json();
        const li = document.createElement("li");
        li.id = `comment_${json.id}`;
        li.innerHTML = `<p>${json.body}</p><small>${json.user?.email || ""}</small>`;
        list.appendChild(li);
        textarea.value = "";
        errorsBox.innerHTML = "";
      } else if (resp.status === 422) {
        const err = await resp.json().catch(() => ({ errors: ["Validation error"] }));
        showErrors(err.errors || ["Validation error"]);
      } else {
        showErrors([`Error: ${resp.status}`]);
      }
    } catch (err) {
      console.error("[comments] request failed", err);
      showErrors(["Failed to send comment"]);
    } finally {
      enableSubmit();
    }
  });

}

export function autoInitComments() {
  document
    .querySelectorAll('form[data-comment-list][data-create-url]')
    .forEach(setupCommentForm);
}
