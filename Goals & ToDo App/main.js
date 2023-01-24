// Array that holds the todo list items
let todoItems = [];

function renderTodo(todo) {
    // Select the first element with a class of 'js-todo-list'
    const list = document.querySelector('.js-todo-list');

    // Use the ternery operator to check if 'todo.checked' is true if so,
    // assign 'done' to isChecked. Otherwise, assign an empty string
    const isChecked = todo.checked ? 'done': '';
    // Create an 'li' element and assign it to 'node'
    const node = document.createElement("li");
    // Set the class attribute
    node.setAttribute('class', 'todo-item ${isChecked}');
    // Set the data-key attribute to the id of the todo
    node.setAttribute('data-key', todo.id);
    // Set the contents of the 'li' element created above 
    node.innerHTML = '
        <input id="${todo.id}" type="checkbox"/>
        <label for="${todo.id}" class="tick js-tick"></label>
        <span>${todo.text}</span>
        <button class="delete-todo js-delete-todo">
        </button>
    ';
    list.append(node);
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