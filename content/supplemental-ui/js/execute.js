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
    console.log('Showroom Execute: DOM ready state:', document.readyState);

    // Find all code blocks with execute class
    // Antora renders role="execute" as <div class="listingblock execute">
    const executeBlocks = document.querySelectorAll('div.listingblock.execute');

    console.log(`Showroom Execute: Found ${executeBlocks.length} execute blocks`);

    if (executeBlocks.length === 0) {
      console.warn('Showroom Execute: No execute blocks found! Checking for alternative selectors...');
      const allListingBlocks = document.querySelectorAll('div.listingblock');
      console.log(`Showroom Execute: Total listingblock divs: ${allListingBlocks.length}`);
      allListingBlocks.forEach(function(block, index) {
        if (index < 5) {
          console.log(`Showroom Execute: Block ${index} classes:`, block.className);
        }
      });
    }

    executeBlocks.forEach(function(block, index) {
      console.log(`Showroom Execute: Processing block ${index}`);
      addExecuteButton(block);
    });
  }

  function addExecuteButton(block) {
    console.log('Showroom Execute: Adding button to block');

    // Find the code element - it's nested: div.content > pre > code
    const codeElement = block.querySelector('code');
    if (!codeElement) {
      console.warn('Showroom Execute: No code element found in block');
      return;
    }

    const command = codeElement.textContent.trim();
    console.log('Showroom Execute: Command:', command.substring(0, 50) + '...');

    // Create execute button and add to the content div
    const contentDiv = block.querySelector('.content');
    if (!contentDiv) {
      console.warn('Showroom Execute: No content div found');
      return;
    }

    // Create execute button
    const executeBtn = document.createElement('button');
    executeBtn.className = 'execute-button';
    executeBtn.title = 'Execute in terminal';
    executeBtn.innerHTML = '▶ Execute'; // Play icon with text
    executeBtn.style.cssText = `
      position: absolute;
      top: 5px;
      right: 5px;
      background: #0066cc;
      color: white;
      border: none;
      padding: 6px 12px;
      cursor: pointer;
      border-radius: 4px;
      font-size: 11px;
      font-weight: bold;
      z-index: 10;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    `;

    executeBtn.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('Showroom Execute: Button clicked!');
      executeCommand(command);

      // Visual feedback
      executeBtn.style.background = '#00aa00';
      executeBtn.innerHTML = '✓ Executed';
      setTimeout(function() {
        executeBtn.style.background = '#0066cc';
        executeBtn.innerHTML = '▶ Execute';
      }, 1000);
    });

    // Make the content div position relative so absolute positioning works
    contentDiv.style.position = 'relative';

    // Add button to content div
    contentDiv.appendChild(executeBtn);
    console.log('Showroom Execute: Button added successfully');
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
