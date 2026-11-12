function switchProfileSection(sectionName, event, updateHistory) {
    if (event && event.preventDefault) {
        event.preventDefault();
    }

    var target = sectionName || 'profile';

    document.querySelectorAll('.profile-section').forEach(function (el) {
        el.classList.toggle('is-active', el.getAttribute('data-section') === target);
    });

    document.querySelectorAll('.sidebar-menu a[data-section]').forEach(function (link) {
        link.classList.toggle('active', link.getAttribute('data-section') === target);
    });

    if (target === 'wishlist' && typeof window.initWishlistSection === 'function') {
        window.initWishlistSection();
    }

    if (updateHistory !== false) {
        var nextUrl = '/profile?section=' + encodeURIComponent(target);
        if (window.location.pathname + window.location.search !== nextUrl) {
            history.pushState({ section: target }, '', nextUrl);
        }
    }

    var main = document.querySelector('.profile-main');
    if (main) {
        var offset = main.getBoundingClientRect().top + window.pageYOffset - 88;
        window.scrollTo(0, Math.max(0, offset));
    }

    return false;
}

window.addEventListener('popstate', function (e) {
    var sectionFromState = e.state && e.state.section;
    var sectionFromUrl = new URLSearchParams(window.location.search).get('section');
    switchProfileSection(sectionFromState || sectionFromUrl || 'profile', null, false);
});

document.addEventListener('DOMContentLoaded', function () {
    var active = document.querySelector('.profile-section.is-active');
    if (active && active.getAttribute('data-section') === 'wishlist' && typeof window.initWishlistSection === 'function') {
        window.initWishlistSection();
    }
});

// Common JavaScript functions
function toggleEditMode() {
    const viewMode = document.getElementById('viewMode');
    const editMode = document.getElementById('editMode');
    const editButton = document.querySelector('.btn-edit');

    if (viewMode && editMode) {
        if (viewMode.style.display !== 'none') {
            viewMode.style.display = 'none';
            editMode.style.display = 'block';
            if (editButton) {
                editButton.innerHTML = '<i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel Edit';
            }
        } else {
            viewMode.style.display = 'block';
            editMode.style.display = 'none';
            if (editButton) {
                editButton.innerHTML = '<i class="fa-solid fa-pen" aria-hidden="true"></i> Edit';
            }
        }
    }
}

function cancelOrder(orderId) {
    if (!confirm('Are you sure you want to cancel this order?')) {
        return;
    }
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/orders/' + orderId + '/cancel';
    document.body.appendChild(form);
    form.submit();
}
