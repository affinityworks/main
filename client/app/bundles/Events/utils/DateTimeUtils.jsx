import moment from 'moment';

export const formatDate = (date) => {
  if (date)
    return moment(date).format('M/D/Y');
};

export const formatDateTime = (datetime) => {
  if (datetime)
    return moment(datetime).format('Y-M-D H:mm');
};

export const formatDay = (datetime) => {
  if (datetime)
    return moment(datetime).format("dddd, MMMM Do");
};

export const formatTime = (datetime) => {
  if (datetime)
    return moment(datetime).format('hA');
}
