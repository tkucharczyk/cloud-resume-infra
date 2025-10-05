document.getElementById("downloadPdf").addEventListener("click", function () {
    const element = document.getElementById("doc2");
    element.style.transform = 'scale(0.9)';
    element.style.transformOrigin = 'top left';

    const options = {
        margin:       0,
        filename:     'Tomasz_Kucharczyk_CV.pdf',
        image:        { type: 'jpeg', quality: 0.98 },
        html2canvas:  { scale: 2, useCORS: true, scrollX: 0, scrollY: 0, windowWidth: 794 },
        jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' },
         pagebreak:    { mode: ['avoid-all', 'css', 'legacy'] }
};

    html2pdf().set(options).from(element).save();
});

async function fetchVisitCount() {
    const apiEndpoint = "${api_gateway_url}/visit";

    try {
        const response = await fetch(apiEndpoint);
        if (!response.ok) {
            throw new Error("HTTP error! status: " + response.status);
        }

        const data = await response.json();

        const visitCount = data.VisitCount; 
        document.getElementById('visit-counter').innerText = "Visits: " + visitCount;
    } catch (error) {
        console.error('Error fetching visit count:', error);
        document.getElementById('visit-counter').innerText = 'Error loading visits';
    }
}

async function registerVisit() {
    const apiEndpoint = "${api_gateway_url}/registerVisit";

    try {
        // Wyślij żądanie POST
        const response = await fetch(apiEndpoint, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });

        if (!response.ok) {
            throw new Error("HTTP error! status: " + response.status);
        }

        console.log('Visit registered successfully');
    } catch (error) {
        console.error('Error registering visit:', error);
    }
}

window.onload = function () {
    registerVisit(); 
    fetchVisitCount(); 
};
