package com.demo.fullstack.config;

import com.demo.fullstack.model.Task;
import com.demo.fullstack.repository.TaskRepository;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class DataInitializer implements ApplicationRunner {

    private final TaskRepository taskRepository;

    public DataInitializer(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (taskRepository.count() > 0) {
            return;
        }

        List<Task> tasks = List.of(
                new Task(null, "Welcome to Full Stack Demo", "Explore the API and UI.", false, null, null),
                new Task(null, "Create your first task", "Use the form to add a task.", false, null, null),
                new Task(null, "Mark a task complete", "Check off tasks you finish.", true, null, null)
        );

        taskRepository.saveAll(tasks);
    }
}
