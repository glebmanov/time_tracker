export const TimerHook = {
  mounted() {
    this.setup();
  },

  updated() {
    this.cleanup();
    this.setup();
  },

  destroyed() {
    this.cleanup();
  },

  setup() {
    const startedAt = this.el.dataset.startedAt;
    const total = parseInt(this.el.dataset.total || "0", 10);
    const isActive = this.el.dataset.active === "true";
    const timerId = `timer-${this.el.id.split("-")[1]}`;
    const timerEl = document.getElementById(timerId);

    if (!isActive || !startedAt || !timerEl) return;

    const startTime = new Date(startedAt);
    this.interval = setInterval(() => {
      const now = new Date();
      const seconds = Math.floor((now - startTime) / 1000);
      timerEl.textContent = this.format(seconds);
    }, 1000);
  },

  cleanup() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
  },

  format(sec) {
    const h = Math.floor(sec / 3600);
    const m = Math.floor((sec % 3600) / 60);
    const s = sec % 60;

    return [
      h.toString().padStart(2, "0"),
      m.toString().padStart(2, "0"),
      s.toString().padStart(2, "0"),
    ].join(":");
  },
};
