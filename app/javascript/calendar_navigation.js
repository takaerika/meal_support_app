// app/javascript/calendar_navigation.js
function setupCalendarNavigation() {
  const calendar = document.getElementById("calendar");
  if (calendar) {
    // data-year と data-month から YYYY-MM を作る（monthは1〜12想定）
    const year  = calendar.dataset.year;
    const month = calendar.dataset.month.toString().padStart(2, "0");

    calendar.addEventListener("click", (e) => {
      const el = e.target;
      if (!(el instanceof HTMLElement)) return;
      if (el.classList.contains("day-name")) return;
      const dayText = el.textContent?.trim();
      if (!dayText) return;

      const day = dayText.padStart(2, "0");
      const dateStr = `${year}-${month}-${day}`;
      window.location.href = `/meal_records?date=${dateStr}`;
    });
  }

  const recordButton = document.getElementById("recordButton");
  if (recordButton) {
    recordButton.addEventListener("click", (e) => {
      e.preventDefault();
      const d = new Date();
      const yyyy = d.getFullYear();
      const mm   = String(d.getMonth() + 1).padStart(2, "0");
      const dd   = String(d.getDate()).padStart(2, "0");
      window.location.href = `/meal_records/new?date=${yyyy}-${mm}-${dd}`;
    });
  }
}

// Turbo Drive 対応（Rails 7 デフォルト）
document.addEventListener("turbo:load", setupCalendarNavigation);
// 初期ロード用（Turbo無効時など）
document.addEventListener("DOMContentLoaded", setupCalendarNavigation);