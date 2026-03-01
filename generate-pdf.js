const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();
    
    await page.goto('http://localhost:8080/brochure.html', { 
        waitUntil: 'networkidle',
        timeout: 60000 
    });

    await page.waitForTimeout(3000);

    await page.pdf({
        path: 'C:\\Users\\William\\Desktop\\Projects\\Finca_Serenity_2025.pdf',
        width: '297mm',
        height: '210mm',
        printBackground: true,
        preferCSSPageSize: true,
        scale: 1,
        margin: { top: 0, right: 0, bottom: 0, left: 0 }
    });

    console.log('PDF generated successfully');
    await browser.close();
})();
