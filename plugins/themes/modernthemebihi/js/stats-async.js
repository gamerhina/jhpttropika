document.addEventListener('DOMContentLoaded', function() {
    var statElements = document.querySelectorAll('.async-stats-view');
    if (statElements.length === 0) return;

    var articleIds = [];
    var galleyIds = [];

    statElements.forEach(function(el) {
        var type = el.getAttribute('data-type');
        var id = el.getAttribute('data-id');
        if (!id) return;
        
        if (type === 'article' && articleIds.indexOf(id) === -1) {
            articleIds.push(id);
        } else if (type === 'galley' && galleyIds.indexOf(id) === -1) {
            galleyIds.push(id);
        }
    });

    if (articleIds.length === 0 && galleyIds.length === 0) return;

    // Get the base URL path from OJS settings or infer from current URL.
    // OJS URLs generally follow /index.php/{journal_path}/...
    var pathParts = window.location.pathname.split('/');
    var journalPath = '';
    
    // Find index.php in the path and get the next segment (journal path)
    var indexPos = pathParts.indexOf('index.php');
    if (indexPos !== -1 && pathParts.length > indexPos + 1) {
        journalPath = pathParts[indexPos + 1];
    } else {
        // Handle restful URLs or index.php being hidden
        // Fallback: take the first segment after root if not empty
        journalPath = pathParts[1] || '';
    }
    
    var baseUrl = window.location.origin;
    if (indexPos !== -1) {
        baseUrl += pathParts.slice(0, indexPos + 1).join('/');
    } else {
        // Fallback for RESTful URLs
        baseUrl += window.location.pathname.substring(0, window.location.pathname.indexOf(journalPath));
    }
    
    var endpoint = baseUrl + '/' + journalPath + '/modernthemebihi/getStats';
    
    // Fallback if URL inference is wrong (e.g. site level)
    if (!journalPath || journalPath === 'index') {
        // Can't reliably infer journal context, return
        // You could also parse pkp.registry if available
        if (typeof pkp !== 'undefined' && pkp.context && pkp.context.apiBaseUrl) {
            // Can extract journal path from apiBaseUrl
        }
    }

    var formData = new FormData();
    formData.append('articleIds', articleIds.join(','));
    formData.append('galleyIds', galleyIds.join(','));

    fetch(endpoint, {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(function(response) {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.json();
    })
    .then(function(data) {
        statElements.forEach(function(el) {
            var type = el.getAttribute('data-type');
            var id = el.getAttribute('data-id');
            var val = 0;
            
            if (type === 'article' && data.articles && data.articles[id] !== undefined) {
                val = data.articles[id];
            } else if (type === 'galley' && data.galleys && data.galleys[id] !== undefined) {
                val = data.galleys[id];
            }
            
            // Apply a nice fade-in effect
            el.style.opacity = 0;
            setTimeout(function() {
                el.innerHTML = val;
                el.style.transition = 'opacity 0.5s';
                el.style.opacity = 1;
            }, 50);
        });
    })
    .catch(function(error) {
        console.error('Error fetching async stats:', error);
        // Fallback for UI if error
        statElements.forEach(function(el) {
            el.innerHTML = 'N/A';
        });
    });
});
