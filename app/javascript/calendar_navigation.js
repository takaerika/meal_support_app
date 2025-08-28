// app/javascript/calendar_navigation.js
function setupCalendarNavigation() {
  const calendar = document.getElementById("calendar");
  if (calendar) {
    const year  = calendar.dataset.year;
    const month = calendar.dataset.month.toString().padStart(2, "0");
    const basePath = calendar.dataset.basePath;

    // 日付セルだけにイベントを設定
    calendar.querySelectorAll(".day-cell").forEach(cell => {
      cell.addEventListener("click", () => {
        const day = cell.dataset.day;
        if (!day) return;

        const dayPadded = day.toString().padStart(2, "0");
        const dateStr = `${year}-${month}-${dayPadded}`;

        // 遷移先URL
        window.location.href = `${basePath}?date=${dateStr}&year=${year}&month=${month}`;
      });
    });
  }

  // 「今日の食事を記録する」ボタン
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

// Turbo Drive 対応
document.addEventListener("turbo:load", setupCalendarNavigation);
document.addEventListener("DOMContentLoaded", setupCalendarNavigation);