document.getElementById("downloadPdf").addEventListener("click", function () {
    const element = document.getElementById("doc2");

    const options = {
        margin: 2,
        filename: 'moja_strona.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
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
