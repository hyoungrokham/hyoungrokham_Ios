import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var addbutton: UIButton!
    
    var todos: [TodoItem] = []
    var selectedDate: Date?
                
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textfield.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TodoCopyCell")
        let todo = todos[indexPath.row]

        // 할 일 제목 설정
        cell.textLabel?.text = todo.title

        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium  // 날짜 형식을 조금 더 읽기 쉽게 변경

        // 마감 기한이 있을 경우 포맷하여 표시, 없으면 "No deadline"
        if let deadline = todo.deadline {
            cell.detailTextLabel?.text = "Due: \(dateFormatter.string(from: deadline))"
        } else {
            cell.detailTextLabel?.text = "No deadline"
        }

        // 완료 상태에 따른 체크마크 표시
        cell.accessoryType = todo.isCompleted ? .checkmark : .none

        return cell
    }

    
    func presentDatePicker(for taskTitle: String) {
        let alertController = UIAlertController(title: "Select Deadline", message: "\n\n\n\n\n", preferredStyle: .alert)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 5, y: 50, width: 250, height: 120)
        alertController.view.addSubview(datePicker)

        let selectAction = UIAlertAction(title: "Select", style: .default) { [unowned self] _ in
            let selectedDate = datePicker.date
            let newItem = TodoItem(title: taskTitle, isCompleted: false, deadline: selectedDate)
            self.addTodoItem(newItem)
            self.textfield.text = ""  // 텍스트 필드를 클리어
        }
        let noDeadlineAction = UIAlertAction(title: "No Deadline", style: .default) { [unowned self] _ in
            let newItem = TodoItem(title: taskTitle, isCompleted: false, deadline: nil)
            self.addTodoItem(newItem)
            self.textfield.text = ""  // 텍스트 필드를 클리어
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(selectAction)
        alertController.addAction(noDeadlineAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    func addTodoItem(_ item: TodoItem) {
        todos.append(item)
        let newIndexPath = IndexPath(row: todos.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].isCompleted = !todos[indexPath.row].isCompleted
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()  // 키보드 숨기기
            return true
        }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let text = textfield.text, !text.isEmpty {
                    presentDatePicker(for: text)
                }
    }

}

