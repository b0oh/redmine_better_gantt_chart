Event.observe(window, 'load', function() {

  var isTask = function (fromId, task) {
    return task.readAttribute('id') && task.readAttribute('id') !== fromId;
  };

  var submit = function (fromId, toId) {
    var form = document.createElement('form'),
        addInput = function (name, value) {
          var input = document.createElement('input');
          input.type = "hidden";
          input.name = name;
          input.value = value;
          form.appendChild(input);
        };

    form.action = "/relations/new";
    form.method = "get";

    addInput("issue_id", fromId);
    addInput("issue_to_id", toId);

    var body = document.getElementsByTagName('body')[0];
    body.insertBefore(form, body.firstChild);
    form.submit();
  };

  var process = function (handler) {
    return function (button) {
      var fromId = button.readAttribute('data-issue-id');

      Event.observe(button, 'click', function () {
        $$('.tooltip').invoke('hide');

        $$('div.task_todo')
          .findAll(isTask.bind(null, fromId))
          .invoke('addClassName', 'clickable')
          .each(function (task) {
            Event.observe(task, 'click', handler(fromId, task.readAttribute('id')));
          });
      });
    };
  };

  $$('button.precedes').each(
    process(function (fromId, toId) {
      return function () {
        submit(fromId, toId);
      };
    })
  );

  $$('button.follow').each(
    process(function (fromId, toId) {
      return function () {
        submit(toId, fromId);
      };
    })
  );
});