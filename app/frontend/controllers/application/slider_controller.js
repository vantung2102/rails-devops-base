import { Controller } from '@hotwired/stimulus';

/** HTML: data-slider-target tokens must match these names exactly (camelCase), e.g. progressBar not progress-bar. */
export default class extends Controller {
  static targets = ['slide', 'dot', 'progressBar', 'indexDisplay', 'prevButton', 'nextButton'];

  connect() {
    this.index = 0;
    this.boundKey = this.onKey.bind(this);
    window.addEventListener('keydown', this.boundKey);
    this.showSlide();
  }

  disconnect() {
    window.removeEventListener('keydown', this.boundKey);
  }

  onKey(event) {
    if (event.key === 'ArrowRight') {
      event.preventDefault();
      this.next();
    }
    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      this.prev();
    }
  }

  next() {
    const last = this.slideTargets.length - 1;
    if (this.index < last) {
      this.index += 1;
      this.showSlide();
    }
  }

  prev() {
    if (this.index > 0) {
      this.index -= 1;
      this.showSlide();
    }
  }

  goTo(event) {
    const i = Number.parseInt(event.currentTarget.dataset.slideIndex, 10);
    if (Number.isFinite(i) && i >= 0 && i < this.slideTargets.length) {
      this.index = i;
      this.showSlide();
    }
  }

  showSlide() {
    const total = this.slideTargets.length;
    const last = total - 1;

    this.slideTargets.forEach((el, i) => {
      el.classList.toggle('is-active', i === this.index);
      el.setAttribute('aria-hidden', i === this.index ? 'false' : 'true');
    });

    this.dotTargets.forEach((el, i) => {
      el.classList.toggle('is-active', i === this.index);
      el.setAttribute('aria-current', i === this.index ? 'true' : 'false');
    });

    if (this.hasIndexDisplayTarget) {
      this.indexDisplayTarget.textContent = String(this.index + 1);
    }

    if (this.hasProgressBarTarget) {
      const pct = ((this.index + 1) / total) * 100;
      this.progressBarTarget.style.width = `${pct}%`;
    }

    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.disabled = this.index === 0;
    }

    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.disabled = this.index === last;
    }
  }
}
