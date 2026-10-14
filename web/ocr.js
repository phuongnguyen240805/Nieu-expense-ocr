// The worker processes the image in this browser. Only recognition assets are downloaded.
window.expenseOcr = {
  async recognize(image) {
    if (!window.Tesseract) {
      throw new Error('Bộ nhận diện chưa tải xong. Vui lòng thử lại.');
    }
    const worker = await Tesseract.createWorker('vie+eng', 1, {
      workerPath: 'https://cdn.jsdelivr.net/npm/tesseract.js@6.0.1/dist/worker.min.js',
      corePath: 'https://cdn.jsdelivr.net/npm/tesseract.js-core@6.0.0',
    });
    try {
      const { data: { text } } = await worker.recognize(image);
      return text;
    } finally {
      await worker.terminate();
    }
  },
};
