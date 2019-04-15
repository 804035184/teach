// mixin
import Issue from '../../../issues/models/issue'
import DateMixin from './date_support'
import mdWrapper from '../md_wrapper.vue'

export default {
  mixins: [DateMixin],
  data() {
    return {
      projects: [],
      labels: {},
      members: {},
      milestones: {},
    }
  },
  components: {
    mdWrapper
  },
  props: {
    issue: Issue,
  },
  mounted() {
    const $navbar = document.getElementById('navbar');
    const projects = JSON.parse($navbar.dataset.projects);

    for (let project of projects) {
      this.labels[project.id] = project.labels.filter((l) => !['To Do', 'Doing'].includes(l.name));
      this.members[project.id] = project.members;
      this.milestones[project.id] = project.milestones;
      this.projects.push({
        id: project.id,
        name: project.name,
        name_with_namespace: project.name_with_namespace,
      });
    }
  },
  methods: {
    milestoneList(issue) {
      return this.milestones[issue.projectId];
    },
    labelList(issue) {
      return this.labels[issue.projectId];
    },
    memberList(issue) {
      return this.members[issue.projectId];
    }
  },
  computed: {
    canEdit() {
      return true;
    }
  },
}