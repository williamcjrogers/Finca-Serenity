const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();

    const htmlPath = path.resolve(__dirname, 'brochure.html');
    await page.goto(`file:///${htmlPath.replace(/\\/g, '/')}`, { waitUntil: 'networkidle0', timeout: 30000 });

    await page.pdf({
        path: path.resolve(__dirname, 'Finca-Serenity-Brochure.pdf'),
        width: '297mm',
        height: '210mm',
        printBackground: true,
        margin: { top: 0, right: 0, bottom: 0, left: 0 },
        preferCSSPageSize: true
    });

    await browser.close();
    console.log('PDF created');
})();
