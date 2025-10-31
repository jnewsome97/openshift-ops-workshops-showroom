/**
 * Showroom Execute Functionality
 * Adds execute buttons to code blocks with role="execute"
 * Similar to Homeroom/Bookbag functionality
 */

(function() {
  'use strict';

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  function init() {
    console.log('Showroom Execute: Initializing...');

    // Find all code blocks with role="execute"
    const executeBlocks = document.querySelectorAll('pre.highlight[class*="execute"], div.listingblock[class*="execute"]');

    console.log(`Showroom Execute: Found ${executeBlocks.length} execute blocks`);

    executeBlocks.forEach(function(block) {
      addExecuteButton(block);
    });
  }

  function addExecuteButton(block) {
    // Find the code element
    const codeElement = block.querySelector('code');
    if (!codeElement) return;

    const command = codeElement.textContent.trim();

    // Find or create the toolbar
    let toolbar = block.querySelector('.toolbar');
    if (!toolbar) {
      toolbar = document.createElement('div');
      toolbar.className = 'toolbar';
      block.appendChild(toolbar);
    }

    // Create execute button
    const executeBtn = document.createElement('button');
    executeBtn.className = 'execute-button';
    executeBtn.title = 'Execute in terminal';
    executeBtn.innerHTML = '▶'; // Play icon
    executeBtn.style.cssText = `
      background: #0066cc;
      color: white;
      border: none;
      padding: 4px 8px;
      margin-left: 4px;
      cursor: pointer;
      border-radius: 3px;
      font-size: 12px;
    `;

    executeBtn.addEventListener('click', function(e) {
      e.preventDefault();
      executeCommand(command);

      // Visual feedback
      executeBtn.style.background = '#00aa00';
      setTimeout(function() {
        executeBtn.style.background = '#0066cc';
      }, 500);
    });

    // Add to toolbar
    toolbar.insertBefore(executeBtn, toolbar.firstChild);
  }

  function executeCommand(command) {
    console.log('Showroom Execute: Running command:', command);

    // Try to find the terminal iframe
    // The terminal is in the parent window at /terminal
    let terminalFrame = null;

    if (window.parent !== window) {
      // We're in an iframe (the content iframe)
      // Try to find sibling terminal iframe
      try {
        const parentDoc = window.parent.document;
        terminalFrame = parentDoc.querySelector('iframe[src*="/terminal"]') ||
                       parentDoc.querySelector('iframe#terminal_01');
      } catch (e) {
        console.error('Cannot access parent document:', e);
      }
    }

    if (terminalFrame && terminalFrame.contentWindow) {
      // Send command to terminal using postMessage
      terminalFrame.contentWindow.postMessage({
        type: 'execute',
        command: command + '\n'
      }, '*');

      // Also try direct method if terminal supports it
      try {
        if (terminalFrame.contentWindow.term) {
          terminalFrame.contentWindow.term.paste(command + '\n');
        }
      } catch (e) {
        console.log('Direct terminal access not available, using postMessage');
      }
    } else {
      console.error('Showroom Execute: Terminal iframe not found');
      alert('Terminal not found. Please ensure the terminal tab is loaded.');
    }
  }
})();
