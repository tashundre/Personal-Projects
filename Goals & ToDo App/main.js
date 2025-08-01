// Array that holds the todo list items
let todoItems = [];

function renderTodo(todo) {
    localStorage.setItem('todoItemsRef', JSON.stringify(todoItems));

    // Select the first element with a class of 'js-todo-list'
    const list = document.querySelector('.js-todo-list');
    // Select the current todo item in the DOM
    const item = document.querySelector(`[data-key='${todo.id}']`);

    if (todo.deleted) {
        item.remove();
        // add this line to clear whitespace from the list container
        // when 'todoItems' is empty
        if (todoItems.length === 0) list.innerHTML = '';
        return
    }

    // Use the ternery operator to check if 'todo.checked' is true if so,
    // assign 'done' to isChecked. Otherwise, assign an empty string
    const isChecked = todo.checked ? 'done': '';
    // Create an 'li' element and assign it to 'node'
    const node = document.createElement("li");
    // Set the class attribute
    node.setAttribute('class', `todo-item ${isChecked}`);
    // Set the data-key attribute to the id of the todo
    node.setAttribute('data-key', todo.id);
    // Set the contents of the 'li' element created above 
    node.innerHTML = `
        <input id="${todo.id}" type="checkbox"/>
        <label for="${todo.id}" class="tick js-tick"></label>
        <span>${todo.text}</span>
        <button class="delete-todo js-delete-todo">
        <svg><use href="#delete-icon"></use></svg>
        </button>
    `;

    // if the item already exsists in the DOM
    if (item) {
        // replace it
        list.replaceChild(node, item);
    } else {
        // otherwise append it to the end of the list
        list.append(node);
    }
}

// Create a todo item based on the text that is entered in the text input,
// and push it into the todo item array.
function addTodo(text) {
    const todo = {
        text,
        checked: false,
        id: Date.now(),
    };

    todoItems.push(todo);
    renderTodo(todo);
}

function toggleDone(key) {
    // findIndex is an array method that returns the position of an element
    // in the array.
    const index = todoItems.findIndex(item => item.id === Number(key));
    // locate the todo item in the todoItems array and set its checked 
    // property to the opposite. That means, 'true' will become 'false' and vice versa.
    todoItems[index].checked = !todoItems[index].checked;
    renderTodo(todoItems[index]);
}

function deleteTodo(key) {
    // find the corresponding todo object in the todoItems array
    const index = todoItems.findIndex(item => item.id === Number(key));
    // create a nre object with properties of the current todo item
    // and a 'deleted' property which is set to true
    const todo = {
        deleted: true,
        ...todoItems[index]
    };
    // remove the todo item from the array by filtering it out
    todoItems = todoItems.filter(item => item.id !== Number(key));
    renderTodo(todo);
}

// Select the form element
const form = document.querySelector('.task-form');

// Add a submit event listener
form.addEventListener('submit', event =>{
    // prevent page refresh on form submission
    event.preventDefault();
    // Select the text input
    const input = document.querySelector('.task-input');

    // Get the value of the input and remove whitespace
    const text = input.value.trim();
    if (text !== '') {
        addTodo(text);
        input.value=''
        input.focus();
    }   
});

// Select the entire list
const list = document.querySelector('.js-todo-list');
// Add a click event listener to the list and its children
list.addEventListener('click', event => {
    if (event.target.classList.contains('js-tick')){
        const itemKey = event.target.parentElement.dataset.key;
        toggleDone(itemKey);
    }
    
    if (event.target.classList.contains('js-delete-todo')) {
        const itemKey = event.target.parentElement.dataset.key;
        deleteTodo(itemKey);
    }

    });

    document.addEventListener('DOMContentLoaded', () => {
        const ref = localStorage.getItem('todoItemsRef');
        if (ref) {
            todoItems = JSON.parse(ref);
            todoItems.forEach (t => {
                renderTodo(t);
            });
        }
    })