# Murmuration CI Pipeline Project with ParlAI by Jamaine Azubuike

The goal of this project is to create a CI/CD Pipeline for an open-source Python-based platform that helps researchers share, train, and test dialog models.

<img width="535" alt="Screenshot 2024-03-17 at 10 42 05 PM" src="https://github.com/zubujams/ParlAI/assets/52971863/5b1798be-ad51-4342-8937-28f90c4dcf1e">


## 1. Planning
Tools and Process:

Jira: Used by product owners to create and manage stories. This tool is essential for planning, tracking, and reporting on work throughout the software development lifecycle.
GitHub: Serves as the version control system where developers will push their code. It acts as the central repository that maintains the version history and provides collaboration features.

Create and Design: Product owners are responsible for outlining the application's requirements and converting them into user stories in Jira. They prioritize these stories to guide the development process according to the project's goals and the client's needs.

#### Challenges: There aren't as many challenges here for a devops engineer as the planning is handled by business stakeholders/product. Perhaps consulting a devops engineer at this stage can help set expectation on how the app can be built and managed.

## 2. Development
Developers' Workflow:

Building the App: Developers write code to build the ParlAI application, implementing the features and requirements specified in the Jira stories.
Version Control: After writing the code, developers push their updates to GitHub, initiating the CI/CD pipeline. GitHub acts as the collaborative platform for code reviews and managing pull requests before integration.

#### Challenges: Hopefully in a real CICD environment, developers should all have the same tools and development environments provisioned for consistency when writing code. However, this is solved by having the devs push code into a SCM tool like github.

## 3. Building
Automated Building and Packaging code:

GitHub Actions: With the app already being hosted in Github, I decided to use Github Actions for simplicity. Github actions can automates the building and packaging of the application using Conda for dependency management and creating a consistent build environment.
Unit Testing: pytest is used within GitHub Actions to run unit tests, ensuring that the code behaves as expected before it's deployed.
Docker Deployment: After testing, the code is deployed to a Docker image using a Dockerfile, and the Docker image is then pushed to a development environment on AWS.

#### Challenges:
- Finding a build tool best suited for this project: While a python app is easier to work with when building, it comes with specific considerations.
 I first wanted to use Poetry to build/package the app, however, especially when dealing with complex dependencies or conflicts between packages, using [Poetry](https://python-poetry.org/) can lead to build failures or the need for workarounds.
 This is why I elected to use [Conda](https://anaconda.org/conda-forge/python) or Anaconda as a build tool. Conda works seamlessly with the code and is already being used in the projects Dockerfile.

- Also, I had to remove the CircleCI yml that was handling the process previously. This could cause problems with the build process in a productiong environment but overall Github actions streamlines the build without using ouside tools.

## 4. Testing
Quality Assurance and User Acceptance:

QA Testing: The application undergoes Quality Assurance (QA) testing in a dedicated environment where test cases are executed to verify the functionality and performance against the requirements.

UAT: User Acceptance Testing (UAT) follows, where end-users validate the application against their expectations.

Feedback Loop: Any feedback from QA testers or UAT is communicated back to the developers for revisions. This ensures a continuous improvement loop where issues are addressed promptly.

Approval: Once the application passes QA and UAT, it is approved for deployment to the production environment.

#### Challenges: Testing can always be difficult especially when trying to maintain the testing enviroment.

## 5. Deployment
Monitoring and Production Environment:

Production Deployment: The application is deployed to the production environment, which is monitored to ensure its performance and stability.

Monitoring Stack: The ELK Stack, Prometheus, and AWS CloudWatch are employed to monitor the application comprehensively, providing insights into logs, metrics, and operational health.

Infrastructure Provisioning and Management:
Terraform: Utilized for defining and provisioning the cloud infrastructure in an automated manner. Check murmuration-ci/main.tf file 

AWS CloudFormation: Can be used for managing and configuring the resources provisioned by Terraform, ensuring that the cloud infrastructure is set up according to best practices and requirements. 

Challenges:
