document.addEventListener("click", (e) => {
  const btn = e.target.closest(".remove-nested-link");
  if (!btn) return;
  e.preventDefault();
  const wrap = btn.closest(".nested-fields");
  const destroy = wrap.querySelector('input[data-destroy-field="true"]');
  if (destroy) destroy.value = "1";
  wrap.style.display = "none";
});
